#! /bin/bash

### The main logic of this script is placed in the main() function;
### We only want the main function to be called if this script is sourced (not sh-ed)
### This script uses a 'trick' to tell if it's being sourced or sh-ed

main() {
    clear

    echo "
    =======================================================

    Initializing Python Virtual Environment

    =======================================================
    "

    sleep 1

    ### 0. Get rid of cached versions
    rm -rf .mypy_cache
    rm -rf src/__pycache__

    ### 1. Load vars defined in .env
    if [[ -f .env ]]; then
        eval $(cat .env | sed 's/^/export /')
    else
        echo "
            No .env file found! Failing set up.
            Copy and edit from '.env-template'
        "
        return 1
    fi

    ### 2. Make sure there's a .config.cfg file for flask_dashboardmonitor
    if [[ ! -f .config.cfg ]]; then
        echo "
            No '.config.cfg' file found! Exiting set up.
            A template can be found here: https://flask-monitoringdashboard.readthedocs.io/en/master/configuration.html
        "
        return 1
    fi

    ### 3. Make sure there's a DB file for flask_dashboardmonitor
    if [[ ! -f .dashboard.db ]]; then
        echo "No file '.dashboard.db' found; creating now"
        touch .dashboard.db
    fi

    ### 4. Check for existence of `.venv` dir
    if [[ ! -d ./.venv ]]; then
        echo "Virtual Environment Not Found -- Creating './.venv'"
        $PYTHON_3_5_OR_HIGHER -m venv .venv
    fi

    ### 5. Activate VENV
    source ./.venv/bin/activate

    ### 6. Upgrade pip
    pip install --upgrade pip

    ### 7. Install Requirements to VENV
    pip install -r requirements.txt

    ### 8. Link git pre-commit-hook script
    ln -fs $PWD/_precommit_hook.sh $PWD/.git/hooks/pre-commit

    echo """
        Set up complete. Enjoy Flask API-ing!
    """
}

if [[ $1 == 'jenkins' ]]; then
    ## Jenkins will error if you use the trick in the else clause
    echo "Running from jenkins"
    main
else
    ## Trick to check if this script is being sourced or sh-ed
    unset BASH_SOURCE 2>/dev/null
    test ".$0" == ".$BASH_SOURCE" && echo "You must <SOURCE> (not SH) this script!!!" || main "$@"
fi
