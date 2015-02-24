## Last Representers

[![Build Status](https://img.shields.io/travis/last/last-representers.svg?style=flat-square)](https://travis-ci.org/last/last-representers)

A builder DSL for serializing resources (as Ruby Hashes or JSON Strings) and [JSON Schema](http://json-schema.org/) documents (as Ruby Hashes or JSON Strings). The serialized resource should validate against the generated JSON Schema.

### Usage

#### Defining a Representer

```ruby
class AccountRepresenter < Last::Representers::Representer
  expose :id,    :property, in: :summary, as: [:string]
  expose :first, :property, in: :summary, as: [:string]
  expose :last,  :property, in: :summary, as: [:string, :null]
  expose :age,   :property, in: :summary, as: [:integer, :null], required: false

  expose :location, :relationship, in: :detail, using: -> { LocationRepresenter }
  expose :home,     :relationship, in: :detail, using: -> { LocationRepresenter }
  expose :work,     :relationship, in: :detail, using: -> { LocationRepresenter }

  expose :access_token, :property, in: :full, as: [:string]
end

class LocationRepresenter < Last::Representers::Representer
  expose :id,          :property, in: :summary, as: [:string]
  expose :name,        :property, in: :summary, as: [:string]
  expose :coordinates, :property, in: :summary, as: [:array]

  expose :visitors, :relationship, in: :detail, using: -> { AccountRepresenter }, list: true
end
```

Above we have a representer for two resources: Account and Location. There are a number of `expose` clauses describing which fields should be present in the serialized JSON of a particular object. Representers provide three ways to describe resources:

- `:summary`:  Simple view of a single resource
- `:detail`: Typically the full view of a resource including its related properties
- `:full`: Exposes all fields. Typically reserved for fields that should be accessed with caution.

Note that `:detail` includes `:summary` fields and `:full` includes both `:detail` and `:summary` fields.

#### Serializing to JSON

```ruby
AccountRepresenter.new(account).to_json(:detail)
```

In this example we're taking an account resource and serializing it to JSON. Calling the `#to_json` method on its own wouldn't give us the schema we want (as defined in the Representer above). Instead we're asking the Representer for a JSON strategy to apply to the `#to_json` call. We inform it that we'd like the `:detail` view of the resource and it returns a structure accepted by `#to_json` to properly filter the fields.
