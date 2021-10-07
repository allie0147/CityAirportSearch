# CityAirportSearch

### Coordinator process
- coordinator `start()` → `viewModelBuilder`
- viewController `viewModelBuilder` → viewModel `init`
- viewModel `process(dependencies:)` → `routingAction`
- coordinator `start()` → `viewModel.router` 
