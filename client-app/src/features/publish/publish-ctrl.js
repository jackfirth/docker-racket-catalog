import {makeRacketSymbol} from '../../services/racket-symbol';

export default function PublishCtrl(PublishSvc) {
  const publishCtrl = this;
  publishCtrl.newPackage = {};
  publishCtrl.publishNewPackage = () => {
    PublishSvc.publishPackage(publishCtrl.newPackage)
      .then((response) => console.log('Success: ', response));
  };
}
