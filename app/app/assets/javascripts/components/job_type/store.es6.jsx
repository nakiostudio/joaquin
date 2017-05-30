const createStore = window.Redux.createStore;

// Actions
class JobTypeAction {

  static get loading() {
    return 'JOB_TYPE_LOADING';
  }

  static get updated() {
    return 'JOB_TYPE_UPDATED';
  }

  static get showPicker() {
    return 'JOB_TYPE_SHOW_PICKER';
  }

  static get hidePicker() {
    return 'JOB_TYPE_HIDE_PICKER';
  }

}

// Initial sstate
const initialState = {
  loading: true, showPicker: false, data: null
};

// Reducer
const jobTypeStore = createStore((state, action) => {
  switch (action.type) {
    case JobTypeAction.loading:
      return Object.assign({}, state, { loading: true });
    case JobTypeAction.updated:
      return Object.assign({}, state, { loading: false, data: action.data });
    case JobTypeAction.showPicker:
      return Object.assign({}, state, { showPicker: true });
    case JobTypeAction.hidePicker:
      return Object.assign({}, state, { showPicker: false });
  }
  return initialState;
}, window.STATE_FROM_SERVER);
