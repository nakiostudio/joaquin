class JoaquinPanel extends React.Component {
  render() {
    return (
      <MUI.Card style={{marginBottom: 20}}>
        <MUI.Toolbar>
          <MUI.ToolbarGroup firstChild={true} style={{paddingLeft: 16}}>
            <MUI.ToolbarTitle text={this.props.title} style={{fontSize: "medium", color: "black"}}/>
          </MUI.ToolbarGroup>
          <MUI.ToolbarGroup lastChild={true} style={{paddingRight: 16}}>
            {this.props.options}
          </MUI.ToolbarGroup>
        </MUI.Toolbar>
          { this.props.children }
      </MUI.Card>
    );
  }
}

JoaquinPanel.propTypes = {
  title: PropTypes.any,
  options: PropTypes.any
}
