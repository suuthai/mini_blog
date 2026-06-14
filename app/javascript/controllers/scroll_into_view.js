export const scrollIntoView = (element, options = {}) =>
  element?.scrollIntoView({ block: "nearest", ...options });
