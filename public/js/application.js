$(document).ready(function() {
  // This is called after the document has loaded in its entirety
  // This guarantees that any elements we bind to will exist on the page
  // when we try to bind to them
  $("#search").click(function(event){
    event.preventDefault();
    var APP_ID = 'b68a708c'
    var APP_KEY = 'c990231d1ec74289fff36220ae4ba6fb'
    var keywords = $('#input-text').val();
    console.log(keywords)
    // var url = "http://www.yummly.com/v1/api/recipes?q="+keywords+"&_app_id=" + APP_ID + "&_app_key=" + APP_KEY + "&";
    var url = "http://api.yummly.com/v1/api/recipes?_app_id=" + APP_ID + "&_app_key=" + APP_KEY + "&" + keywords;
    $.ajax({
      type: 'GET',
      url: url,
      dataType: 'JSONP',
      success: function (response) {
        // function parseApiData(data) {
        //   // ajax call here
        //   $.ajax({
        //     type: 'post',
        //     url: //,
        //     // data: APIresponse,
        //     dataType: 'JSONP'
        //   }).done(function(serverData) {
        //     // append to DOM or render in some fashion
        //   })
    debugger
      console.log(response);
      // $('#results').html(parseData(response))
      displayRecipes(response)
    }
    }).fail(function(){
      console.log("failed")
      })

  })
  //      })
  //    .done(function(response){
  //       console.log("success!")
  //       $("#results").html(  JSON.stringify(response) );
  //       console.log(response)
  //      })


  //        // success: function() { console.log('Success!'); },
  //        // error: function(data, data2) { console.log(data); },
  //        // jsonp: false,
  //        // jsonpCallback: 'recipeGet'
  // });

  // See: http://docs.jquery.com/Tutorials:Introducing_$(document).ready()
});

function parseData(currentObject, key) {
  for (var property in currentObject) {
    if (typeof currentObject[property] === "object") {
      parseData(currentObject[property], property);
    } else {
     $('#results').append(property + ' -- ' + currentObject[property] + '<br />');
   }
 }
}

function displayRecipes(response) {
  matches = response.matches

  matches.forEach(function(element) {
    var recipeId = element.id
    var img = element.imageUrlsBySize[90]
    var ingredients_array = element.ingredients
    var rating = element.rating
    var recipeName = element.recipeName
    var displayName = element.displayName
    var totalTime = element.totalTimeInSeconds

    $('#results').append('<h1>' + recipeName + '</h1>')
    $('#results').append('<img src=' + img + '>')
    ingredients_array.forEach(function(element, index) {
      $('#results').append('<p>' + (index + 1) + '.  '+ element + '</p>')
    })

    $('#results').append('<p>Rating: ' + rating + ' stars</p>')
    $('#results').append('<p>Total Time: ' + (totalTime / 60) + ' minutes</p>')
  })

}


// function getRecipes(url) {
//   // Retrieve Handlebars template from the HTML
//   var source = $('#recipe-template').html();
//   var template = Handlebars.compile(source);
//   var context = {recipes: []};

//   $.ajax({
//     url: url,
//   }).done(function(response) {
//     context.squirrels = response.response.children;
//     $('#results').html(template(context));
//   });
// }

// $(document).ready(function() {
//   getSquirrels();
// });