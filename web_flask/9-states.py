#!/usr/bin/python3
"""
task 9
"""

from flask import Flask, render_template
from models import storage
from models.state import State
from models.city import City

app = Flask(__name__)


@app.teardown_appcontext
def teardown_appcontext(exception):
    """Remove the current SQLAlchemy Session."""
    storage.close()


@app.route('/states', strict_slashes=False)
def states():
    """Display a list of all State objects present in DBStorage."""
    states = sorted(storage.all(State).values(), key=lambda state: state.name)
    return render_template('states.html', states=states)


@app.route('/states/<id>', strict_slashes=False)
def state_by_id(id):
    """Display details for a specific State, including linked City objects."""
    state = storage.get(State, id)
    if state:
        cities = sorted(state.cities, key=lambda city: city.name)
        return render_template('state_by_id.html', state=state, cities=cities)
    else:
        return render_template('not_found.html')


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
