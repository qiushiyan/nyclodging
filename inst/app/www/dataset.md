<div class = "col-sm-12">

<style>
summary:focus { 
  outline: none 
}
</style>


<h2>About the dataset</h2>

This application aims to explore and visualize Airbnb listings in NYC in 2019. It contains measurements on host, room description, room type, reviews, 
availability, geographic location, etc. 

<br/>
<br/>

You can jump to other sections: 


<br/>
<br/>

<ul>
<li><a href = "javascript:void(0)" onclick = "distribution()">Distribution of single variable</a></li>
<li> <a href = "javascript:void(0)" onclick = "relationship()">Relationship between variables</a></li>
<li> <a href = "javascript:void(0)" onclick = "spatialAnalysis()">Spatial Analysis</a></li>
<li> <a href = "javascript:void(0)" onclick = "textAnalysis()">Text Analysis</a></li>
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
</script>


<details>
  <summary>
  Click to expand data dictionary 
  </summary>
data dictionary 
</details>

</div>
