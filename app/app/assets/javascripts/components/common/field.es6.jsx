class JoaquinField extends React.Component {
  constructor() {
    super();
    this.state = {
      value: '',
      errorMessage: null
    };
  }

  componentDidMount() {
    this.setState({value: this.props.value ? this.props.value : ''});
  }

  componentWillReceiveProps(nextProps) {
    this.setState({value: nextProps.value ? nextProps.value : ''});
  }

  onChange(event) {
    this.setState({
      value: event.target.value ? event.target.value : '',
      errorMessage: null
    });
  }

  onBlur(event) {
    console.log(event.target.value);
    var errorMessage = null;
    for (var validator of (this.props.validators || [])) {
      if (!RegExp(validator.regex).test(event.target.value)) {
        errorMessage = validator.message;
        break;
      }
    }
    this.setState({
      value: event.target.value ? event.target.value : '',
      errorMessage: errorMessage
    });

    this.props.onChange(event);
  }

  value() {
    return this.state.value;
  }

  stringField() {
    return (
      <input
        className="form-control"
        type="text"
        onBlur={this.onBlur.bind(this)}
        onChange={this.onChange.bind(this)}
        value={this.value()}
      />
    );
  }

  textField() {
    return (
      <textarea
        className="form-control"
        rows="5"
        onBlur={this.onBlur.bind(this)}
        onChange={this.onChange.bind(this)}
        value={this.value()}
      />
    );
  }

  field() {
    if (this.props.type == "string") {
      return  this.stringField();
    }
    return this.textField();
  }

  description() {
    if (!this.props.description && !this.state.errorMessage) {
      return null;
    }
    return (
      <small id="helpBlock" className="help-block">
        { this.state.errorMessage || this.props.description }
      </small>
    );
  }

  render() {
    const errorClassName = this.state.errorMessage ? "has-error" : ""
    return (
      <div className={"form-group " + errorClassName}>
        <label>{ this.props.title }</label>
        { this.field() }
        { this.description() }
      </div>
    );
  }
}

JoaquinField.propTypes = {
  type: React.PropTypes.string,
  title: React.PropTypes.string,
  description: React.PropTypes.string,
  value: React.PropTypes.any,
  validators: React.PropTypes.any,
  onChange: React.PropTypes.any
};
