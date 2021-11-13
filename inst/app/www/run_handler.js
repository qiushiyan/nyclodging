$( document ).ready(() => {
  Shiny.addCustomMessageHandler('run', function(arg) {
    console.log(arg)
  })
});
