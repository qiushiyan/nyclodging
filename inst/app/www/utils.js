const removeModal = () => {
  $("body").removeClass("modal-open");
  
  $("#shiny-modal-wrapper, .modal-backdrop").remove()
}

const setInputValue = (id, value, priority = "event") => {
  alert(value)
  Shiny.setInputValue(id, value, { priority })
}