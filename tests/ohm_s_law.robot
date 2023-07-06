*** Settings ***
Documentation      Tests the owhm's with a power supply and a resistor

Metadata           Author            "XdoctorwhoZ"

Resource           bench.resource
Suite Setup        Setup Bench Config
Suite Teardown     Cleanup Bench Config

*** Variables ***

${test_psu}           demo_psu
${test_ammeter}       demo_ammeter

${start_voltage}      1
${end_voltage}        10
${step_voltage}       0.5

${resistor_value}     100

*** Test Cases ***

Generate Graph
    # Set the power supply in a safe mode
    Turn Off Power Supply     ${test_psu}

    # Initialize data lists
    @{voltages}=     Create List
    @{readings}=     Create List
    @{expectings}=   Create List
    @{deltas}=       Create List

    # Adjust the end value to include it into the test
    ${adjusted_end_voltage}    evaluate   ${end_voltage} + ${step_voltage}

    # Set a current limit
    Set Power Supply Current Goal    ${test_psu}    1

    # For each goal voltage and steps
    FOR    ${goal_voltage}    IN RANGE    ${start_voltage}    ${adjusted_end_voltage}    ${step_voltage}

        # Power on and wait the voltage to come up
        Set Power Supply Voltage Goal    ${test_psu}    ${goal_voltage}
        Turn On Power Supply     ${test_psu}
        Sleep    2

        # Save goal voltage
        Append To List    ${voltages}    ${goal_voltage}

        # Read and Save current measure
        ${current_reading}=    Read Ammeter Measure    ${test_ammeter}
        Append To List    ${readings}    ${current_reading}

        # Compute and Save expected value
        ${expected_reading}    evaluate   ${goal_voltage} / ${resistor_value}
        Append To List    ${expectings}    ${expected_reading}

        # Compute and save the delta error
        ${delta}    evaluate   abs(${current_reading} - ${expected_reading})
        Append To List    ${deltas}    ${delta}

        # Come back to original state
        Sleep    0.2
        Turn Off Power Supply     ${test_psu}

    END

    # Create and log the result chart
    ${chart}=     Create Chart Line    "Results"    ${voltages}
    Chart Line Add    ${chart}    "Measured\(A\)"     ${readings}
    Chart Line Add    ${chart}    "Expected(A)"       ${expectings}
    Chart Line Add    ${chart}    "Deltas"            ${deltas}
    Log Chart    ${chart}

