{
  global: {},
  components: {
    // Component-level parameters, defined initially from 'ks prototype use ...'
    // Each object below should correspond to a component in the components/ directory
    "pets-pvc": {
      accessMode: 'ReadWriteMany',
      name: 'pets-pvc',
      storage: '20Gi',
    },
    "get-data-job": {
      mountPath: '/pets_data',
      mounthPath: '/pets_data',
      name: 'get-data-job',
      pvc: 'pets-pvc',
      urlAnnotations: 'http://www.robots.ox.ac.uk/~vgg/data/pets/data/annotations.tar.gz',
      urlData: 'http://www.robots.ox.ac.uk/~vgg/data/pets/data/images.tar.gz',
      urlModel: 'http://download.tensorflow.org/models/object_detection/faster_rcnn_resnet101_coco_2018_01_28.tar.gz',
      urlPipelineConfig: 'https://raw.githubusercontent.com/kubeflow/examples/master/object_detection/conf/faster_rcnn_resnet101_pets.config',
    },
    "decompress-data-job": {
      mountPath: '/pets_data',
      name: 'decompress-data-job',
      pathToAnnotations: '/pets_data/annotations.tar.gz',
      pathToDataset: '/pets_data/images.tar.gz',
      pathToModel: '/pets_data/faster_rcnn_resnet101_coco_2018_01_28.tar.gz',
      pvc: 'pets-pvc',
    },
    "create-pet-record-job": {
      dataDirPath: '/pets_data',
      image: 'lcastell/pets_object_detection',
      mountPath: '/pets_data',
      name: 'create-pet-record-job',
      nodeSelector: {
        "node-type": 'amina',
      },
      outputDirPath: '/pets_data',
      pvc: 'pets-pvc',
    },
    "tf-training-job": {
      image: 'lcastell/pets_object_detection',
      mountPath: '/pets_data',
      name: 'tf-training-job',
      numGpu: 1,
      numPs: 1,
      numWorkers: 10,
      pipelineConfigPath: '/pets_data/faster_rcnn_resnet101_pets.config',
      pvc: 'pets-pvc',
      tfjobApiVersion: 'kubeflow.org/v1',
      trainDir: '/pets_data/train',
    },
    "export-tf-graph-job": {
      inputType: 'image_tensor',
      pipelineConfigPath: '/pets_data/faster_rcnn_resnet101_pets.config',
      trainedCheckpoint: '/pets_data/train/model.ckpt-<number>',
      outputDir: '/pets_data/exported_graphs',
      image: 'lcastell/pets_object_detection',
      mountPath: '/pets_data',
      name: 'export-tf-graph-job',
      pvc: 'pets-pvc',
    },
    model1: {
      cloud: 'gcp',
      deployHttpProxy: true,
      gcpCredentialSecretName: 'user-gcp-sa',
      modelPath: 'gs://kai-test2-models/object-detection',
      modelServerImage: 'gcr.io/kubeflow-images-public/tensorflow-serving-1.8gpu:latest',
      name: 'coco',
      numGpus: 1,
    },
    "pets-model": {
      defaultCpuImage: 'tensorflow/serving:1.10.0',
      defaultGpuImage: 'tensorflow/serving:1.10.0-gpu',
      deployHttpProxy: true,
      modelPath: '/mnt/exported_graphs/saved_model',
      modelStorageType: 'nfs',
      nfsPVC: 'pets-pvc',
      name: 'pets-model',
    },
    "pets-pvc2": {
      accessMode: 'ReadWriteMany',
      storage: '20Gi',
    },
  },
}