import sqlite3
from sqlite3 import Connection
from typing import List, Set, Tuple


class Item:
    def __init__(self, id: int, name: str):
        self.id = id
        self.name = name

    def __str__(self):
        return self.name


class ProductionPlantType:
    def __init__(self, id: int, name: str):
        self.id = id
        self.name = name

    def __str__(self):
        return self.name


class Process:
    def __init__(self,
                 id: int,
                 name: str,
                 input_items: List[Tuple[Item, int]],
                 output_items: List[Tuple[Item, int]],
                 production_plant: ProductionPlantType,
                 time: float):
        self.id = id
        self.name = name
        self.input_items = input_items
        self.output_items = output_items
        self.time = time
        self.production_plant = production_plant

    def get_output_items_with_rates(self):
        return {i[0]: i[1] / self.time for i in self.output_items}

    def get_input_items_with_rates(self):
        return {i[0]: i[1] / self.time for i in self.input_items}

    def __str__(self):
        return '{}\ninput: {}\noutput: {}\ntime: {}\nplant: {}'.format(
            self.name,
            ['{}: {}\n'.format(item[0], item[1]) for item in self.input_items],
            ['{}: {}\n'.format(item[0], item[1]) for item in self.output_items],
            self.time,
            self.production_plant
        )


class FactorioStructure:
    def __init__(self):
        with sqlite3.connect('../factorio.db') as con:
            self._init_db(con)
            self.items: List[Item] = self._read_items(con)
            self.plant_types = self._read_plant_types(con)
            self.processes = self._read_processes(con, self.plant_types, self.items)

    @staticmethod
    def _init_db(connection: Connection):
        with open('init.sql') as f:
            connection.executescript(''.join(f.readlines()))

    @staticmethod
    def _read_items(connection: Connection) -> List[Item]:
        items = []
        cursor = connection.cursor()
        for record in cursor.execute('SELECT * from items').fetchall():
            items.append(Item(record[0], record[1]))
        return items

    @staticmethod
    def _read_plant_types(connection: Connection) -> List[ProductionPlantType]:
        plant_types = []
        cursor = connection.cursor()
        for record in cursor.execute('SELECT * from plant_types').fetchall():
            plant_types.append(ProductionPlantType(record[0], record[1]))
        return plant_types

    @staticmethod
    def _read_processes(connection: Connection,
                        plant_types: List[ProductionPlantType],
                        items: List[Item]) -> List[Process]:
        processes = []
        cursor = connection.cursor()
        for record in cursor.execute('SELECT * from process').fetchall():
            process_id = record[0]
            process_name = record[1]
            process_time = record[2]
            plant = list(filter(lambda p: p.id == record[3], plant_types))[0]
            inputs = []
            for input_record in cursor.execute(
                    'SELECT * from process_input where process_id = {}'.format(process_id)).fetchall():
                inputs.append((list(filter(lambda i: i.id == input_record[1], items))[0], input_record[2]))

            outputs = []
            for output_record in cursor.execute(
                    'SELECT * from process_output where process_id = {}'.format(process_id)).fetchall():
                outputs.append((list(filter(lambda i: i.id == output_record[1], items))[0], output_record[2]))
            processes.append(Process(process_id, process_name, inputs, outputs, plant, process_time))

        return processes

    def __str__(self):
        return 'items: {}\n\nplants: {}\n\nprocesses {}'.format(self.items, self.plant_types, self.processes)
