*** Settings ***

Library      Collections
Library      panduza.robof.Keywords

Variables    bench_data.py

*** Keywords ***

Setup Bench Config
    Set Log Level    DEBUG
    Log     ${PZA_ALIASES}
    Load Pza Interfaces From Aliases    ${PZA_ALIASES}
