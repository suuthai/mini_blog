export const scrollIntoView = (element, options = {}) =>
  element?.scrollIntoView({ behavior: "smooth", block: "nearest", ...options });
