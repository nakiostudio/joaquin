class JoaquinField extends React.Component {
  constructor() {
    super();
    this.state = {
      value: '',
      errorMessage: null
    };
  }

  // Override functions and callbacks

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

  // Propreties

  value() {
    return this.state.value;
  }

  // Styles

  // Field types

  stringField() {
    return (
      <MUI.TextField
        hintText={this.props.placeholder}
        floatingLabelText={this.props.title}
        floatingLabelFixed={true}
        errorText={this.state.errorMessage}
        onBlur={this.onBlur.bind(this)}
        onChange={this.onChange.bind(this)}
        value={this.value()}
        fullWidth={true}
        underlineStyle={{color: Colors.fullBlack}}
        style={{marginTop: -10, marginBottom: -10}}
      />
    );
  }

  textField() {
    return (
      <MUI.TextField
        rows={5}
        multiLine={true}
        hintText={this.props.placeholder}
        floatingLabelText={this.props.title}
        floatingLabelFixed={true}
        errorText={this.state.errorMessage}
        onBlur={this.onBlur.bind(this)}
        onChange={this.onChange.bind(this)}
        value={this.value()}
        fullWidth={true}
        style={{marginTop: -10, marginBottom: -10}}
        textareaStyle={{
          backgroundColor: Colors.grey50,
          padding: 5,
          fontSize: "small",
          lineHeight: 1.4,
          fontFamily: "Source Code Pro"
        }}
      />
    );
  }

  description() {
    if (this.state.errorMessage) {
      return null;
    }
    return (
      <p style={{marginTop: 8, fontSize: "85%", color: Colors.grey400}}>
        {this.props.description}
      </p>
    );
  }

  render() {
    let field = null;
    if (this.props.type == "string") {
      field = this.stringField();
    }
    else if (this.props.type = "text") {
      field = this.textField();
    }
    return (
      <div>
        {field}
        {this.description()}
      </div>
    );
  }
}

JoaquinField.propTypes = {
  type: PropTypes.string,
  title: PropTypes.string,
  description: PropTypes.string,
  value: PropTypes.any,
  placeholder: PropTypes.any,
  validators: PropTypes.any,
  onChange: PropTypes.any
};
