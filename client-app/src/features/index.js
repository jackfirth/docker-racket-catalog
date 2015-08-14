import PackagesCtrl from './packages/packages-ctrl';
import PublishCtrl from './publish/publish-ctrl';
import ToolbarConfig from './toolbar/toolbar-config';

export default {
  controllers: {
    PackagesCtrl: ['PackagesSvc', PackagesCtrl],
    PublishCtrl: [PublishCtrl]
  },
  configs: {
    ToolbarConfig: ['$stateProvider', '$urlRouterProvider', ToolbarConfig]
  }
};
