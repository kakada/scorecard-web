CW.VotesShow = (() => {
  return { init };

  function init() {
    initCongratsAnimation();
  }

  function initCongratsAnimation() {
    const $congrats = $('#congrats');
    const doneAnimationEl = document.getElementById('doneAnimation');

    if ($congrats.length === 0 || !doneAnimationEl) return;

    // Swap animations after a short delay with a smooth fade
    setTimeout(() => {
      $congrats.fadeOut(400);

      lottie.loadAnimation({
        container: doneAnimationEl,
        renderer: 'svg',
        loop: false,
        autoplay: true,
        path: $(doneAnimationEl).data('icon-url')
      });
    }, 1400);
  }
})();
