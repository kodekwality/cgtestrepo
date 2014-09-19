function () {
  var duration = +new Date() - start.time,
    isPastHalf = Number(duration) < 250 && Math.abs(delta.x) > 20 || Math.abs(delta.x) > viewport / 2,
    direction = delta.x < 0;

  if (!isScrolling) {
    if (isPastHalf) {
      if (direction) {
        this.close();
      } else {
        if (this.content.getBoundingClientRect().left > viewport / 2 && pulled === true) {
          this.close();
          return;
        }
        this.open();
      }
    } else {
      if (this.content.getBoundingClientRect().left > viewport / 2) {
        if (this.isEmpty(delta) || delta.x > 0) {
          this.close();
          return;
        }
        this.open();
        return;
      }
      this.close();
    }
  }
}