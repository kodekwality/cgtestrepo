'use strict';

function factorial(num) {
  if(num < 0) {
    return -1;
  } else if(num === 0) {
    return 1;
  } else {
    return (num * factorial(num - 1));
  }
}

console.log('5 factorial is: ', factorial(5));