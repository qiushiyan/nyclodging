const setInputValue = (id, value, priority = "event") => {
    Shiny.setInputValue(id, value, { priority });
};