export function hideElement(element) {
  element.classList.add('hidden')
}

export function showElement(element) {
  element.classList.remove('hidden')
}

export function isMobileDevice() {
  return (typeof window.orientation !== "undefined") || (navigator.userAgent.indexOf('IEMobile') !== -1);
};
