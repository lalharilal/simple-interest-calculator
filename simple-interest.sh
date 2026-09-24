```bash
# Simple Interest Calculator

MAX_RETRIES=3

echo "=============================="
echo "   Simple Interest Calculator"
echo "=============================="
echo "Enter 'q' at any prompt to exit."
echo

# Validate positive numbers
validate_number() {
    local value="$1"
    local field="$2"

    if ! [[ "$value" =~ ^[0-9]+([.][0-9]+)?$ ]]; then
        echo "Error: $field must be a valid positive number."
        return 1
    fi

    if ! awk "BEGIN {exit !($value > 0)}"; then
        echo "Error: $field must be greater than zero."
        return 1
    fi

    return 0
}

# Get and validate input
get_input() {
    local field="$1"
    local prompt="$2"
    local value
    local attempts=0

    while (( attempts < MAX_RETRIES )); do
        read -r -p "$prompt" value

        # Exit option
        if [[ "$value" == "q" || "$value" == "Q" ]]; then
            echo "Exiting calculator. Goodbye!"
            exit 0
        fi

        if validate_number "$value" "$field"; then
            REPLY="$value"
            return 0
        fi

        ((attempts++))
        echo "Attempts remaining: $((MAX_RETRIES - attempts))"
        echo
    done

    echo "Error: Maximum number of attempts reached for $field."
    echo "Exiting calculator."
    exit 1
}

# Get inputs
get_input "Principal Amount" "Enter Principal Amount: "
principal="$REPLY"

get_input "Rate of Interest" "Enter Rate of Interest (%): "
rate="$REPLY"

get_input "Time Period" "Enter Time Period (years): "
time="$REPLY"

# Calculate simple interest
if ! interest=$(awk "BEGIN {printf \"%.2f\", ($principal * $rate * $time) / 100}"); then
    echo "Error: Unable to calculate simple interest."
    exit 1
fi

# Calculate total amount
if ! amount=$(awk "BEGIN {printf \"%.2f\", $principal + $interest}"); then
    echo "Error: Unable to calculate total amount."
    exit 1
fi

echo
echo "------------------------------"
echo "Principal Amount : $principal"
echo "Rate of Interest : $rate%"
echo "Time Period      : $time years"
echo "Simple Interest  : $interest"
echo "Total Amount     : $amount"
echo "------------------------------"
echo "Calculation completed successfully."
```
