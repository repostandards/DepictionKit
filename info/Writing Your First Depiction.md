## Writing Your First Depiction
Depictions are designed in a way that's easy to understand and generate for your packages. Typescript interfaces for writing Depictions can be found [here](https://github.com/RepositoryStandards/TemporarySpecification). 

### Base of the Depiction:
All Depictions follow the same base format. 
```json
{
  "$schema": "./schema.json",
  "tint_color": Color
  "children": [DepictionView]
 }
```
Depictions must contain the three base objects, `$schema`, `tint_color` and `children`.  
* `$schema` is a constant which is used for validating that your Depiction is formatted correctly. 
* `tint_color` is a `Color` object and is used as the global tint color for your depiction
* `children` is an array of `DepictionView` and are the base views that will show in your Depiction. It is important to note that `children` cannot be empty. 

### Adding Views
Depiction Views are made up of two parts. The name and properties. Both are required. Here is an example view:
```json
{
	"name": "HeadingView",
	"properties": {
		"text": "Example Header",
		"alignment": "center"
	}
}
```
* `name` is the string name of the view
* `properties` is a dictionary of the parameters for the view. 

### Adding Depictions to Packages
When setting a depiction for a package you must use the key `Native-Depiction` in your release file. When setting the header image use the key `Header`.
