from typing import List, Dict, Tuple

from models import Item, Process

ADVANCED_OIL_PROCESSING = 'Advanced Oil Processing'
LIGHT_OIL_CRACKING = 'Light Oil Cracking'
HEAVY_OIL_CRACKING = 'Heavy Oil Cracking'

LIGHT_OIL = 'Light Oil'
HEAVY_OIL = 'Heavy Oil'
PETROLEUM_GAS = 'Petroleum Gas'

OIL_PROCESSES = [ADVANCED_OIL_PROCESSING, LIGHT_OIL_CRACKING, HEAVY_OIL_CRACKING]
OIL_ITEMS = [LIGHT_OIL, HEAVY_OIL, PETROLEUM_GAS]


class ProductionPath:
    global_tracker: Dict['ProductionPath', 'ProductionPath'] = {}

    def __init__(self):
        self.str_repr = ''
        self.items_chain: List[Item] = []
        self.process_chain: List[str] = []
        self.rate = 0

    def with_new_segment(self, process_name: str, item: Item) -> 'ProductionPath':
        new_path = ProductionPath()
        new_path.str_repr = self.str_repr + '->' + item.name

        new_path.items_chain = self.items_chain[:]
        new_path.items_chain.append(item)

        new_path.process_chain = self.process_chain[:]
        new_path.process_chain.append(process_name)
        if new_path in ProductionPath.global_tracker:
            return ProductionPath.global_tracker[new_path]
        ProductionPath.global_tracker[new_path] = new_path
        return new_path

    def cut_one(self) -> 'ProductionPath':
        new_path = ProductionPath()

        new_path.items_chain = self.items_chain[1:]
        new_path.str_repr = '->'.join(map(lambda i: i.name, new_path.items_chain))

        new_path.process_chain = self.process_chain[:]
        new_path.rate = self.rate
        return new_path

    def increase_rate(self, rate: float):
        self.rate += rate

    def __str__(self):
        return self.str_repr

    def __eq__(self, other: 'ProductionPath'):
        return self.str_repr == other.str_repr

    def __hash__(self):
        return hash(self.str_repr)


class Manager:
    def allocate_rate(self, item: Item, rate: float, request_path: ProductionPath) -> float:
        pass

    def rate_for_item(self, item: Item):
        pass

    def production_paths(self) -> List[ProductionPath]:
        pass


class ItemManager(Manager):
    def __init__(self, process: Process, central_manager: 'CentralManager'):
        self.number_of_buildings = 0
        self.items = process.output_items
        self.process = process
        self.overall_production_rate: Dict[Item, float] = {i[0]: 0 for i in process.output_items}
        self.allocated_production_rate: Dict[Item, float] = {i[0]: 0 for i in process.output_items}
        self.input_items_rate: Dict[Item, float] = {i[0]: 0 for i in process.input_items}
        self.central_manager = central_manager
        self._production_paths: Dict[ProductionPath, ProductionPath] = {}

    def allocate_rate(self, item: Item, rate: float, request_path: ProductionPath) -> float:
        allocated_rate = 0
        if self.allocated_production_rate[item] < self.overall_production_rate[item]:
            allocated_rate = self.overall_production_rate[item] - self.allocated_production_rate[item]
        while allocated_rate < rate:
            self.number_of_buildings += 1

            iteration_input_items = self.process.get_input_items_with_rates()
            for iter_item in iteration_input_items.keys():
                self.central_manager.request_rate(iter_item, iteration_input_items[iter_item],
                                                  request_path.with_new_segment(self.process.name, iter_item))
                self.input_items_rate[iter_item] += iteration_input_items[iter_item]

            iteration_output_items = self.process.get_output_items_with_rates()
            allocated_rate += iteration_output_items[item]
            for iter_item in self.overall_production_rate.keys():
                self.overall_production_rate[iter_item] += iteration_output_items[iter_item]
        if request_path not in self._production_paths:
            self._production_paths[request_path] = request_path
        self._production_paths[request_path].increase_rate(rate)
        self.allocated_production_rate[item] += rate
        return rate

    def rate_for_item(self, item: Item):
        return self.overall_production_rate[item]

    def has_enough_in_stock(self, item: Item, rate: float):
        return rate <= (self.overall_production_rate[item] - self.allocated_production_rate[item])

    def production_paths(self):
        return self._production_paths.keys()

    def __str__(self):
        output_rates = sorted(self._production_paths.keys(), key=lambda x: x.rate, reverse=True)
        return '{}\n' \
               'Number of buildings: {}\n' \
               'Producing: {}\n' \
               'Consuming: {}\n' \
               'Requests from: \n{}'.format(self.process.name,
                                            self.number_of_buildings,
                                            ''.join(['{}: {}; '.format(k, v) for k, v in
                                                     self.overall_production_rate.items()]) + '\n',
                                            ''.join(['{}: {}; '.format(k, v) for k, v in
                                                     self.input_items_rate.items()]) + '\n',
                                            '\n'.join(['request from \'{}\' for item {} with rate of {};'
                                                      .format('\' -> \''.join(out_rate.process_chain),
                                                              out_rate.items_chain[-1],
                                                              out_rate.rate)
                                                       for out_rate in
                                                       filter(lambda o: len(o.items_chain) > 0, output_rates)]))


class OilManager(Manager):
    def __init__(self, processes: List[Process], central_manager: 'CentralManager'):
        self.processes = processes
        self.light_cracker = ItemManager(list(filter(lambda p: p.name == LIGHT_OIL_CRACKING, processes))[0],
                                         central_manager)
        self.heavy_cracker = ItemManager(list(filter(lambda p: p.name == HEAVY_OIL_CRACKING, processes))[0],
                                         central_manager)
        self.advanced_processor = ItemManager(list(filter(lambda p: p.name == ADVANCED_OIL_PROCESSING, processes))[0],
                                              central_manager)

    def allocate_rate(self, item: Item, rate: float, request_path: ProductionPath) -> float:
        if item.name == HEAVY_OIL:
            return self.advanced_processor.allocate_rate(item, rate, request_path)
        if item.name == LIGHT_OIL:
            allocated_from_advanced = self._try_allocate_from_advanced_processor(item, rate, request_path)
            if allocated_from_advanced > 0:
                return allocated_from_advanced
            self.heavy_cracker.allocate_rate(item, rate, request_path)
        if item.name == PETROLEUM_GAS:
            allocated_from_advanced = self._try_allocate_from_advanced_processor(item, rate, request_path)
            if allocated_from_advanced > 0:
                return allocated_from_advanced
            self.light_cracker.allocate_rate(item, rate, request_path)

    def rate_for_item(self, item: Item):
        if item.name == HEAVY_OIL:
            return self.advanced_processor.rate_for_item(item)
        if item.name == LIGHT_OIL:
            return self.advanced_processor.rate_for_item(item) + self.heavy_cracker.rate_for_item(item)
        if item.name == PETROLEUM_GAS:
            return self.advanced_processor.rate_for_item(item) + self.light_cracker.rate_for_item(item)

    def _try_allocate_from_advanced_processor(self, item: Item, rate: float, production_path: ProductionPath) -> float:
        if self.advanced_processor.has_enough_in_stock(item, rate):
            return self.advanced_processor.allocate_rate(item, rate, production_path)
        return -1

    def __str__(self):
        return 'Advanced oil processing: {}\nHeavy Cracking {}\nLight Cracking {}'.format(
            self.advanced_processor,
            self.heavy_cracker,
            self.light_cracker)


class CentralManager(Manager):
    def __init__(self, processes: List[Process], items: List[Item]):
        self.managers: Dict[Item, Manager] = {}
        self.items = items
        for process in processes:
            if process.name in OIL_PROCESSES:
                continue
            manager = ItemManager(process, self)
            for item in process.output_items:
                self.managers[item[0]] = manager

        oil_manager = OilManager(list(filter(lambda p: p.name in OIL_PROCESSES, processes)), self)
        for item in filter(lambda i: i.name in OIL_ITEMS, items):
            self.managers[item] = oil_manager

    def request_rate(self, item: Item, rate: float, request_path=None) -> float:
        if request_path is None:
            request_path = ProductionPath().with_new_segment('Root', item)
        return self.managers[item].allocate_rate(item, rate, request_path)

    def representation(self):
        representation = ''
        managers: List[Tuple[int, Manager]] = []
        is_oil_written = False
        for item in self.managers.keys():
            if isinstance(self.managers[item], OilManager):
                if not is_oil_written:
                    is_oil_written = True
                    managers.append(
                        (len(self.managers[item].light_cracker.production_paths()), self.managers[item].light_cracker))
                    managers.append(
                        (len(self.managers[item].heavy_cracker.production_paths()), self.managers[item].heavy_cracker))
                    managers.append((len(self.managers[item].advanced_processor.production_paths()),
                                     self.managers[item].advanced_processor))
            else:
                if len(self.managers[item].production_paths()) == 0:
                    continue
                managers.append((len(self.managers[item].production_paths()), self.managers[item]))
        managers = sorted(managers, key=lambda x: x[0], reverse=True)

        total_items_rate = []
        for item in self.items:
            total_items_rate.append((item, self.managers[item].rate_for_item(item)))
        total_items_rate.sort(key=lambda i: i[1], reverse=True)
        representation += '+++++++++++++++++++++++++++++++++++++++++++++++++\n'
        for items_rate in total_items_rate:
            representation += '{}: {}\n'.format(items_rate[0], items_rate[1])
        representation += '+++++++++++++++++++++++++++++++++++++++++++++++++\n'

        for manager in managers:
            representation += '\n=============================================\n'
            representation += 'Process: ' + manager[1].process.name + '\n'
            representation += str(manager[1])

        representation += '\n' + '---------------------------------------------------'.join([''] * 20) + '\n'
        representation += '==================== ITEM PRODUCTION SUMMARY ========================\n'

        items_contained_in_production_path: Dict[Item, List[ProductionPath]] = {}
        for prod_path in ProductionPath.global_tracker:
            for item in prod_path.items_chain:
                if item not in items_contained_in_production_path:
                    items_contained_in_production_path[item] = []
                items_contained_in_production_path[item].append(prod_path)
        representation += self._ladder_formatter(0, list(ProductionPath.global_tracker.values()))
        return representation

    def _ladder_formatter(self, level: int, production_paths: List[ProductionPath]) -> str:
        if len(production_paths) == 0:
            return ''
        production_paths_by_length = sorted(production_paths, key=lambda p: (len(p.items_chain), -p.rate))
        current_length = 1
        i = 0
        representation = ''
        while i < len(production_paths_by_length):
            current_length = len(production_paths_by_length[i].items_chain)
            if current_length > 1:
                i += 1
                continue
            current_production_path = production_paths_by_length[i]
            base_item = current_production_path.items_chain[0]
            merged_production_paths: Dict[ProductionPath, ProductionPath] = {}
            for production_path in production_paths:
                if production_path not in merged_production_paths:
                    merged_production_paths[production_path] = production_path
                else:
                    merged_production_paths[production_path].increase_rate(production_path.rate)
            new_production_paths = list(filter(lambda p: len(p.items_chain) != 0,
                                               map(lambda p: p.cut_one(),
                                                   filter(lambda p: p.items_chain[
                                                                        0] == base_item,
                                                          merged_production_paths.values()))))

            representation += '{}{}: {}\n'.format(''.join([(''.join([' '] * 4) + '|')] * level), current_production_path.items_chain[0],
                                                  current_production_path.rate) \
                              + self._ladder_formatter(level + 1, new_production_paths)
            i += 1

        return representation
