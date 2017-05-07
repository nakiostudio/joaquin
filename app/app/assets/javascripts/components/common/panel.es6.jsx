class JoaquinPanel extends React.Component {
  render() {
    return (
      <div className="panel panel-default">
        <div className="panel-heading">
          { this.props.title }
          { this.props.button }
        </div>
        { this.props.children }
      </div>
    );
  }
}

JoaquinPanel.propTypes = {
  title: React.PropTypes.any,
  button: React.PropTypes.any
}
