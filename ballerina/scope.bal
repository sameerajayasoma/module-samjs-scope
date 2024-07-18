import ballerina/lang.value;

# Represents a value that can be stored in a Scope.
# This can be either a Cloneable value or an isolated object.
public type ScopeValue value:Cloneable|isolated object {};

# Represents the type descriptor for ScopeValue.
public type ScopeValueType typedesc<ScopeValue>;

# Represents a scope that can hold key-value pairs and has a parent-child relationship.
#
# This class allows for the creation and management of scoped values.
public isolated class Scope {
    private final string? key;
    private final ScopeValue? scopeValue;
    private final Scope? parent;

    # Initializes a new Scope instance.
    #
    # + key - The key associated with this scope
    # + value - The value associated with this scope
    # + parent - The parent scope, if any
    isolated function init(string? key, ScopeValue? value, Scope? parent) {
        self.parent = parent;
        self.key = key;
        if value is value:Cloneable {
            self.scopeValue = value.clone();
        } else {
            self.scopeValue = value;
        }
    }

    // public isolated function value(string key, ScopeValueType targetType = <> ) returns targetType = @java:Method {
    //     'class: "org.samjs.ballerina.scope.ExternScopeValue"
    // } external;

    # Retrieves the value associated with the given key from the current scope or its ancestors.
    #
    # + key - The key to look up
    # + return - The value associated with the key, or panics if the key is not found
    public isolated function value(string key) returns ScopeValue {
        if key == self.key {
            lock {
                ScopeValue? scopeValue = self.scopeValue;
                if scopeValue is value:Cloneable {
                    return scopeValue.clone();
                } else {
                    return scopeValue;
                }
            }
        } else {
            Scope? parent = self.parent;
            if parent !is () {
                return parent.value(key);
            }
        }

        panic error("Key not found", key = key);
    };
}

# Creates a new root scope.
# This is the top-level scope that has no parent.
# This is useful for creating a new scope hierarchy.
#
# + return - A new Scope instance
public isolated function rootScope() returns Scope {
    return new Scope(null, null, ());
}

# Creates a new scope with the given key, value, and parent scope.
#
# + key - The key for the new scope
# + value - The value associated with the key
# + parent - The parent scope
# + return - A new Scope instance
public isolated function bind(string key, ScopeValue value, Scope parent) returns Scope {
    return new Scope(key, value, parent);
}

