# Functions must be defined as global.
function global:ExampleFunction {
    [CmdletBinding()]
    PARAM ( ) # Parameters go here.

    DYNAMICPARAM { # Dynamic parameters go here.
        # Dynamic parameters are parameters that are added to the command
        # based on the values of other parameters.
    }

    BEGIN {
        TRAP { continue } # Error handling goes here.
    } # Runs before anything else.

    PROCESS {
        TRAP { continue } # Error handling goes here.
        Write-Host "Hello! I'm from another scope, that's why I have to be defined as a global function."
    } # Runs once for each input.

    CLEAN {
        TRAP { continue } # Error handling goes here.
        # Cleanup code goes here.
    } # Runs after PROCESS and before END.

    END { 
        TRAP { continue } # Error handling goes here.
    } # Runs after everything else.
}