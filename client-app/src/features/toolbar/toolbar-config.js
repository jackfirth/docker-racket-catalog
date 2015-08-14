const stateWithHeader = ($stateProvider, stateName, stateUrl, bodyView) => {
  $stateProvider.state(stateName, {
    url: stateUrl,
    views: {
      header: {
        templateUrl: 'templates/toolbar/toolbar.html'
      },
      body: bodyView
    }
  });
};

const simpleTemplateState = ($stateProvider, stateName) => {
  const bodyView = {
    templateUrl: 'templates/' + stateName + '/' + stateName + '.html'
  };
  const stateUrl = '/' + stateName;
  stateWithHeader($stateProvider, stateName, stateUrl, bodyView);
};

export default ($stateProvider, $urlRouterProvider) => {
  simpleTemplateState($stateProvider, 'publish');
  stateWithHeader($stateProvider, 'root', '', {
    templateUrl: 'templates/packages/packages.html'
  });
};
