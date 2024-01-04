# Functions must be defined as global.
function global:ExampleFunction {
    Write-Host "Hello! I'm from another scope, that's why I have to be defined as a global function."
}