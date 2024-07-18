## Package Overview
The `samjs/scope` package provides a mechanism for managing request-scoped values throughout a process. It offers a way to propagate request-scoped data, cancelation signals, and deadlines across API boundaries and between processes.

This package introduces the concept of a `Scope`, which is a hierarchical structure that can hold key-value pairs. Each `Scope` can have a parent, allowing for the creation of a scope tree. Values can be bound to a scope and retrieved using keys.

## Features

- Create and manage scoped values
- Hierarchical scope structure
- Thread-safe value retrieval

## Usage

To use the `samjs/scope` package, import it in your Ballerina program:

```ballerina
import samjs/scope;
```

### Creating a Scope

You can create a new scope using the `bind` function:

```ballerina
scope:Scope parentScope = scope:rootScope();
scope:Scope newScope = scope:bind("key", "value", parentScope);
```

### Retrieving Values

Values can be retrieved from a scope using the `value` method:

```ballerina
string val = check newScope.value("key").ensureType();
```

## Example

Here's a simple example demonstrating the usage of the `samjs/scope` package:

```ballerina
import samjs/scope;

public function main() {
    scope:Scope rootScope = scope:rootScope();
    scope:Scope childScope = scope:bind("userID", "12345", rootScope);
    scope:Scope grandchildScope = scope:bind("sessionID", "abcde", childScope);

    string userID = check grandchildScope.value("userID").ensureType();
    string sessionID = check grandchildScope.value("sessionID").ensureType();

    io:println("User ID: " + userID);
    io:println("Session ID: " + sessionID);
}
```

## API Documentation

For detailed API documentation, please refer to the API docs of the individual symbols in this package.
