local env = std.extVar("__ksonnet/environments");
local params = std.extVar("__ksonnet/params").components["pets-pvc2"];

local k = import "k.libsonnet";

local pvc = {
  apiVersion: "v1",
  kind: "PersistentVolumeClaim",
  metadata:{
    name: pets-pvc2,
    namespace: env.namespace,
  },
  spec:{
    accessModes: [params.accessMode],
    volumeMode: "Block",
    resources: {
      requests: {
        storage: params.storage,
      },
    },
  },
};

std.prune(k.core.v1.list.new([pvc],))
