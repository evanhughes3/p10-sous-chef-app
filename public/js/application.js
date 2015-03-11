$(document).ready(function() {


  // This is called after the document has loaded in its entirety
  // This guarantees that any elements we bind to will exist on the page
  // when we try to bind to them
  $("#search-form").submit(function(event){
    event.preventDefault();
    // APP_ID = 'b68a708c'
    // APP_KEY = 'c990231d1ec74289fff36220ae4ba6fb'
    var keywords = $('#input-text').val();
    console.log(keywords)
    // var url = "http://www.yummly.com/v1/api/recipes?q="+keywords+"&_app_id=" + APP_ID + "&_app_key=" + APP_KEY + "&";
    // var url = "http://api.yummly.com/v1/api/recipes?_app_id=" + APP_ID + "&_app_key=" + APP_KEY + "&q=" + keywords + "&requirePictures=true&maxResult=100&start=10";
    $.ajax({
      type: 'GET',
      url: '/searchResults/' + keywords,
      dataType: 'json',
    })

    .done(function (response) {
      console.log(response)
      $('#results').empty();
      displayAllRecipes(response)
    })

    .fail(function(response){
      console.log(response)
      console.log("display recipes failed")
    })
  })

  $('body').on('click', '.viewRecipe', displayRecipe)

});


function displayAllRecipes(response) {
  matches = response
  var source   = $("#recipe-template").html();
  var template = Handlebars.compile(source);

  matches.forEach(function(element) {
    var recipeId = element.id
    var img = element.imageUrlsBySize[90]
    var rating = element.rating
    var recipeName = element.recipeName
    var totalTime = element.totalTimeInSeconds

    var context = {recipeId: recipeId, imgUrl: img, rating: rating, time: (totalTime / 60), recipeName: recipeName};
    var html    = template(context);
    $('#results').append(html)
  })

}

function displayRecipe(response) {
  event.preventDefault()
  id = $(this).attr('href')
  $.ajax({
    type: 'GET',
    url: '/recipe/' + id,
  }).done(function(response){
    console.log("made it through");
    console.log(response)
    $('#results').children().remove();
    $('#results').append(response);
  }).fail(function(response){
    console.log("failed display recipe")
    console.log(response)
  })

}
