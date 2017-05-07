class JoaquinField extends React.Component {
  constructor() {
    super();
    this.state = {
      value: ''
    };
  }

  componentWillReceiveProps(nextProps) {
    this.setState({value: nextProps.value});
  }

  onChange(event) {
    this.setState({value: event.target.value});
  }

  value() {
    value = this.state.value ? this.state.value : this.props.value;
    return value ? value : "";
  }

  stringField() {
    return (
      <input className="form-control" type="text" onBlur={this.props.onChange} onChange={this.onChange.bind(this)} value={this.value()}/>
    );
  }

  textField() {
    return (
      <textarea className="form-control" rows="5" onBlur={this.props.onChange} onChange={this.onChange.bind(this)} value={this.value()}/>
    );
  }

  field() {
    if (this.props.type == "string") {
      return  this.stringField();
    }
    return this.textField();
  }

  description() {
    if (!this.props.description) {
      return null;
    }
    return (
      <small id="helpBlock" className="help-block">{ this.props.description }</small>
    );
  }

  render() {
    return (
      <div className="form-group">
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
  onChange: React.PropTypes.any
};
