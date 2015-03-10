$(document).ready(function() {


  // This is called after the document has loaded in its entirety
  // This guarantees that any elements we bind to will exist on the page
  // when we try to bind to them
  $("#search").on('click', function(event){
    event.preventDefault();
    // APP_ID = 'b68a708c'
    // APP_KEY = 'c990231d1ec74289fff36220ae4ba6fb'
    var keywords = $('#input-text').val();
    console.log(keywords)
    console.log(ENV[APP_KEY])
    // var url = "http://www.yummly.com/v1/api/recipes?q="+keywords+"&_app_id=" + APP_ID + "&_app_key=" + APP_KEY + "&";
    var url = "http://api.yummly.com/v1/api/recipes?_app_id=" + APP_ID + "&_app_key=" + APP_KEY + "&" + keywords + "&requirePictures=true&maxResult=100&start=10";
    $.ajax({
      type: 'GET',
      url: url,
      dataType: 'JSONP',
      success: function (response) {
      $('#results').children().remove();
      displayAllRecipes(response)
    }
    }).fail(function(){
      console.log("display recipes failed")
      })
   })

    $('body').on('click', '.viewRecipe', displayRecipe)

});


function displayAllRecipes(response) {
  matches = response.matches

  matches.forEach(function(element) {
    var recipeId = element.id
    var img = element.imageUrlsBySize[90]
    var ingredients_array = element.ingredients
    var rating = element.rating
    var recipeName = element.recipeName
    var displayName = element.displayName
    var totalTime = element.totalTimeInSeconds
    var courses = element.attributes.course
    var flavors = element.flavors
    //var url = 'http://api.yummly.com/v1/api/recipe/' + recipeId // + '?_app_id=' + APP_ID + '&_app_key=' + APP_KEY

    $('#results').append('<h3><a class="viewRecipe" href="' + recipeId + '">' + recipeName + '</a></h3>')
    $('#results').append('<img class="recipe-img" src=' + img + '>')
    // ingredients_array.forEach(function(element, index) {
    //   $('#results').append('<p>' + (index + 1) + '.  '+ element + '</p>')
    // })
    // courses.forEach(function(element) {
    //   $('#results').append('<p>Courses: ' + element + '</p>')
    // })
    // for(var flavor in flavors) {
    //   $('#results').append('<p>' + flavor + ' : ' + (flavors[flavor] * 10).toFixed(1) + '% </p>')
    // }

    $('#results').append('<h5>Rating: ' + rating + ' stars</h5>')
    $('#results').append('<h5>Total Time: ' + (totalTime / 60) + ' minutes</h5>')
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