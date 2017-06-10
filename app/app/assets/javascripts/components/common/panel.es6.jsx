class JoaquinPanel extends React.Component {
  render() {
    const panelType = this.props.type ? this.props.type : "default";
    return (
      <div className={"panel panel-" + panelType}>
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
  title: PropTypes.any,
  type: PropTypes.any,
  button: PropTypes.any
}
