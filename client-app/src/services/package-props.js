import {prop, has, set, lensProp, curry} from 'ramda';

const setProp = curry((prop, v, obj) => set(lensProp(prop), v, obj))
const defaultPropTo = curry((prop, defaultVal, obj) => {
  if (has(prop, obj)) {
    return obj
  } else {
    return setProp(prop, defaultVal, obj)
  }
})
const ensureTransientPackageProperties = defaultPropTo('tags', [])

export default {
  ensureTransientPackageProperties
}
