import ballerina/test;

import samjs/log as slog;

@test:Config
function testScope() returns error? {
    Scope parentScope = rootScope();
    Scope scope1 = parentScope.bind("key1", "value1");
    test:assertEquals(check scope1.value("key1").ensureType(), "value1", "Invalid value for key 'key1' in scope1");

    Scope scope2 = scope1.bind("key2", "value2");
    test:assertEquals(check scope2.value("key1").ensureType(), "value1", "Invalid value for key 'key1' in scope1");
    test:assertEquals(check scope2.value("key2").ensureType(), "value2", "Invalid value for key 'key2' in scope1");

    Scope scope3 = scope1.bind("key3", "value3");
    test:assertEquals(check scope3.value("key1").ensureType(), "value1", "Invalid value for key 'key1' in scope1");
    test:assertEquals(check scope3.value("key3").ensureType(), "value3", "Invalid value for key 'key3' in scope1");
}

@test:Config
function testScopeWithContextualLogging() returns error? {
    slog:Logger rootLogger = slog:defaultLogger();

    Scope scope = rootScope();
    check logSomething(scope.bind("logger", rootLogger));
}

function logSomething(Scope scope) returns error? {
    slog:Logger logger = check scope.value("logger").ensureType();
    logger.printInfo("This is a log message");

    slog:Logger childLogger = logger.withContext(component = "userMgt");
    check logSomethingAgain(scope.bind("logger", childLogger));
}

function logSomethingAgain(Scope scope) returns error? {
    slog:Logger logger = check scope.value("logger").ensureType();
    logger.printInfo("This is a log message");
}
