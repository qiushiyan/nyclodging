


<h2>About the dataset</h2>

<p>This application aims to explore and visualize Airbnb listings in NYC in 2019.</p> 

<p>It contains measurements on host, room description, room type, reviews, 
availability, geographic location, etc.</p>


You can jump to other sections: 

<ul>
<li>
  <a href = "javascript:void(0)" onclick = "distribution()">
  Distribution
  </a>
  <p>
    Histograms, density plots, bar plots of single variable
  </p>
</li>
<li> 
  <a href = "javascript:void(0)" onclick = "relationship()">
  Relationship
  </a>
  <p>
    Correlation plots between variables 
  </p>
</li>
<li>
  <a href = "javascript:void(0)" onclick = "spatialAnalysis()">
  Spatial Analysis &nbsp
  </a>
  <p>
    Geographical analysis of housing price 
  </p>
</li>
<li>
  <a href = "javascript:void(0)" onclick = "textAnalysis()">
  Text Analysis
  </a>
  <p>
    Usage of words and bigrams in listing description 
  </p>
</li>
<li>
  <a href = "javascript:void(0)" onclick = "gallery()">
  Gallery
  </a>
  <p>
    Showcase of miscellaneous interactive plots 
  </p>
</li>
</ul>

<script>
function distribution() {
  $("a[data-value ='Distribution'").click()
}
function relationship() {
  $("a[data-value ='Relationship'").click()
}
function spatialAnalysis() {
  $("a[data-value ='Spatial Analysis'").click()
}
function textAnalysis() {
  $("a[data-value ='Text Analysis'").click()
}
function gallery() {
  $("a[data-value ='Gallery'").click()
}
</script>


See <a href = "https://qiushiyan.github.io/nyclodging/reference/listings.html">here</a> for data dictionary.  

