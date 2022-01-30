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


class Manager:
    def allocate_rate(self, item: Item, rate: float, request_path: str) -> float:
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
        self.requesters: Dict[str, Dict[Item, float]] = {}

    def allocate_rate(self, item: Item, rate: float, request_path: str) -> float:
        allocated_rate = 0
        if self.allocated_production_rate[item] < self.overall_production_rate[item]:
            allocated_rate = self.overall_production_rate[item] - self.allocated_production_rate[item]
        while allocated_rate < rate:
            self.number_of_buildings += 1

            iteration_input_items = self.process.get_input_items_with_rates()
            for key in iteration_input_items.keys():
                self.central_manager.request_rate(key, iteration_input_items[key], request_path + '->' + self.process.name)
                self.input_items_rate[key] += iteration_input_items[key]

            iteration_output_items = self.process.get_output_items_with_rates()
            allocated_rate += iteration_output_items[item]
            for key in self.overall_production_rate.keys():
                self.overall_production_rate[key] += iteration_output_items[key]
        if request_path in self.requesters:
            if item in self.requesters[request_path]:
                self.requesters[request_path][item] += rate
            else:
                self.requesters[request_path][item] = rate
        else:
            self.requesters[request_path] = {}
            self.requesters[request_path][item] = rate
        self.allocated_production_rate[item] += rate
        return rate

    def __str__(self):
        output_rates = []
        for k, v in self.requesters.items():
            for ik, iv in v.items():
                output_rates.append((k, ik, iv))
        output_rates = sorted(output_rates, key=lambda x: x[2], reverse=True)
        return '{}\n' \
               'Number of buildings: {}\n' \
               'Producing: {}\n' \
               'Consuming: {}\n' \
               'Requests from: {}'.format(self.process.name,
                                          self.number_of_buildings,
                                          ''.join(['{}: {}; '.format(k, v) for k, v in
                                                   self.overall_production_rate.items()]) + '\n',
                                          ''.join(['{}: {}; '.format(k, v) for k, v in
                                                   self.input_items_rate.items()]) + '\n',
                                          '\n'.join(['request from {} for item {} with rate of {};'.format(out_rate[0], out_rate[1], out_rate[2]) for out_rate in output_rates]))


class OilManager(Manager):
    def __init__(self, processes: List[Process], items: List[Item], central_manager: 'CentralManager'):
        self.processes = processes
        self.light_cracker = ItemManager(list(filter(lambda p: p.name == LIGHT_OIL_CRACKING, processes))[0], central_manager)
        self.heavy_cracker = ItemManager(list(filter(lambda p: p.name == HEAVY_OIL_CRACKING, processes))[0], central_manager)
        self.advanced_processor = ItemManager(list(filter(lambda p: p.name == ADVANCED_OIL_PROCESSING, processes))[0], central_manager)

        self.heavy_oil = list(filter(lambda i: i.name == HEAVY_OIL, items))[0]
        self.light_oil = list(filter(lambda i: i.name == LIGHT_OIL, items))[0]
        self.petroleum_gas = list(filter(lambda i: i.name == PETROLEUM_GAS, items))[0]

    def allocate_rate(self, item: Item, rate: float, request_path: str) -> float:
        if item.name == HEAVY_OIL:
            return self.advanced_processor.allocate_rate(item, rate, request_path + '->Oil Processor')
        if item.name == LIGHT_OIL:
            remaining_light_oil = self._remaining_items_rate(self.advanced_processor, self.light_oil)
            allocated_light_oil = self.advanced_processor\
                .allocate_rate(item, min(remaining_light_oil, rate), request_path + '->Oil Processor')
            if allocated_light_oil < rate:
                self.heavy_cracker.allocate_rate(item, rate - allocated_light_oil, request_path + '->Oil Processor')
        if item.name == PETROLEUM_GAS:
            remaining_petroleum_gas = self._remaining_items_rate(self.advanced_processor, self.petroleum_gas)
            allocated_petroleum_gas = self.advanced_processor\
                .allocate_rate(item, min(remaining_petroleum_gas, rate), request_path + '->Oil Processor')
            if allocated_petroleum_gas < rate:
                self.light_cracker.allocate_rate(item, rate - allocated_petroleum_gas, request_path + '->Oil Processor')

    def _remaining_items_rate(self, manager: ItemManager, item: Item):
        return manager.overall_production_rate[item] - manager.allocated_production_rate[item]

    def __str__(self):
        return 'Advanced oil processing: {}\nHeavy Cracking {}\nLight Cracking {}'.format(
            self.advanced_processor,
            self.heavy_cracker,
            self.light_cracker)


class CentralManager(Manager):
    def __init__(self, processes: List[Process], items: List[Item]):
        self.managers: Dict[Item, Manager] = {}
        for process in processes:
            if process.name in OIL_PROCESSES:
                continue
            manager = ItemManager(process, self)
            for item in process.output_items:
                self.managers[item[0]] = manager

        oil_manager = OilManager(list(filter(lambda p: p.name in OIL_PROCESSES, processes)), items, self)
        for item in filter(lambda i: i.name in OIL_ITEMS, items):
            self.managers[item] = oil_manager

    def request_rate(self, item: Item, rate: float, request_path: str) -> float:
        return self.managers[item].allocate_rate(item, rate, request_path)

    def representation(self):
        representation = ''
        managers: List[Tuple[int, ItemManager]] = []
        is_oil_written = False
        for item in self.managers.keys():
            if isinstance(self.managers[item], OilManager):
                if not is_oil_written:
                    is_oil_written = True
                    managers.append((len(self.managers[item].light_cracker.requesters), self.managers[item].light_cracker))
                    managers.append((len(self.managers[item].heavy_cracker.requesters), self.managers[item].heavy_cracker))
                    managers.append((len(self.managers[item].advanced_processor.requesters), self.managers[item].advanced_processor))
            else:
                if len(self.managers[item].requesters) == 0:
                    continue
                managers.append((len(self.managers[item].requesters), self.managers[item]))
        managers = sorted(managers, key=lambda x: x[0], reverse=True)

        for manager in managers:
            representation += '\n=============================================\n'
            representation += 'Process: ' + manager[1].process.name + '\n'
            representation += str(manager[1])

        return representation


