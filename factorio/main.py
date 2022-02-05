from managers import CentralManager
from models import FactorioStructure


def launch():
    factorio_structure = FactorioStructure()
    central_manager = CentralManager(factorio_structure.processes, factorio_structure.items)

    solar_panel = list(filter(lambda p: p.name == 'Solar Panel', factorio_structure.items))[0]
    plastic_bar = list(filter(lambda p: p.name == 'Plastic Bar', factorio_structure.items))[0]
    rocket_part = list(filter(lambda p: p.name == 'Rocket Part', factorio_structure.items))[0]
    red_science = list(filter(lambda p: p.name == 'Automation Science Pack', factorio_structure.items))[0]
    green_science = list(filter(lambda p: p.name == 'Logistic Science Pack', factorio_structure.items))[0]
    gray_science = list(filter(lambda p: p.name == 'Military Science Pack', factorio_structure.items))[0]
    blue_science = list(filter(lambda p: p.name == 'Chemical Science Pack', factorio_structure.items))[0]
    purple_science = list(filter(lambda p: p.name == 'Production Science Pack', factorio_structure.items))[0]
    yellow_science = list(filter(lambda p: p.name == 'Utility Science Pack', factorio_structure.items))[0]
    space_science = list(filter(lambda p: p.name == 'Space Science Pack', factorio_structure.items))[0]

    # central_manager.request_rate(rocket_part, 10)
    # central_manager.request_rate(green_science, 5)
    # central_manager.request_rate(gray_science, 5)
    # central_manager.request_rate(blue_science, 5)
    # central_manager.request_rate(purple_science, 5,)
    # central_manager.request_rate(yellow_science, 5)
    central_manager.request_rate(space_science, 1)

    print(central_manager.representation())


if __name__ == '__main__':
    launch()
