# TPGApi
TPG API wrapper to fetch stops and next departures for Geneva's public transport.

## Installation
### Using Cocoapods

Add this line in your PodFile

```
pod 'TPGApi', '~> 0.0'
```


## Usage

To use the API you must have a valid API key, you can request one here http://www.tpg.ch/web/open-data/donnees-tpg

You have to provide wherever you want in the code like this:

```
TPGApi.key = "your key"
```

### List of all stops in Geneva

Stops have it be loaded at least once, this is done asychronously. Once downloaded the stops are cached on the device.
```
StopManager.instance.loadStops(completion: {(commercialStops, physicalStops) in

}, force: false)
```

### Next departures for a stop

Get next departures for stop code 'Gare Cornavin'
```
DeparturesManager.instance.loadNextDeparturesFor(stopCode: "CVIN", completion: {departures in

})
```
