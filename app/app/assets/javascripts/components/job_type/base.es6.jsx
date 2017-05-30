class JobTypeComponent extends React.Component {
  constructor(props) {
    super(props);

    // Redux setup
    this.store = props.store ? props.store : jobTypeStore;
    this.unsubscribe = this.store.subscribe(() => {
      this.setState(Object.assign({}, this.state, this.store.getState()));
    }.bind(this));

    // State
    this.state = this.store.getState();
  }

  componentWillUnmount() {
    // Stop observing Store
    this.unsubscribe();
  }
}
