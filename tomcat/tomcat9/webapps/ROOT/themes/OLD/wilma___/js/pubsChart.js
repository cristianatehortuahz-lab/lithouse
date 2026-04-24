
var pubChart = {
  onLoad: function() {
    this.requestData()
  },

  requestData: function() {
    var containerIdCoAuthor = 'vis_container_coauthor'; //to keep old similar address of old request that was for sparkline
    $.ajax({
        url: `${visualizationUrl}`,
        data: {
  				'render_mode': 'dynamic',
  				'vis': 'person_pub_count',
  				'vis_mode': 'short',
  				'container': containerIdCoAuthor
			  },
        dataType: 'json',
        complete: function(xhr, status) {
          var results = $.parseJSON(xhr.responseText);
          var drawData = results.yearToEntityCountDataTable.map(
            x => { return {date: x.year, value: x.currentEntitiesCount} }
          ).slice(-10);

          pubChart.drawChart(drawData, {
            width: 350,
            height: 150,
            top: 20,
            right: 0,
            bottom: 20,
            left: 25
          })
        }
    })
  },

  drawChart: function(data, options) {
    // var margin = {top: 20, right: 20, bottom: 70, left: 40},
    // width = 600 - margin.left - margin.right,
    // height = 300 - margin.top - margin.bottom;
    var margin = {
      top: options.top || 0,
      right: options.right || 0,
      bottom: options.bottom || 0,
      left: options.left || 0
    },
    width = options.width || 0,
    height = options.height || 0;
    width = width - margin.left - margin.right,
    height = height - margin.top - margin.bottom;

    var x = d3.scaleBand()
      .rangeRound([0, width])
      .padding(0.3);

    var y = d3.scaleLinear()
      .rangeRound([height, 0])

    var svg = d3.select("#pubsChart").append("svg")
        .attr("version", 1.1)
        .attr("xmlns", "http://www.w3.org/2000/svg")
        .attr("width", width + margin.left + margin.right)
        .attr("height", height + margin.top + margin.bottom)
        .attr("viewbox", `0 0 ${width + margin.left + margin.right} ${height + margin.top + margin.bottom}`)
      .append("g")
        .attr("transform",
              "translate(" + margin.left + "," + margin.top + ")");



    // Scale the range of the data in the domains
    x.domain(data.map(function(d) { return d.date; }));
    var yMax = d3.max(data, function(d) { return d.value; });
    y.domain([0, yMax])

    // append the rectangles for the bar chart
    svg.selectAll(".bar")
      .data(data)
      .enter().append("rect")
      .attr("fill", "#850813")
      .attr("x", function(d) { return x(d.date); })
      .attr("width", x.bandwidth())
      .attr("y", function(d) { return y(d.value); })
      .attr("height", function(d) { return height - y(d.value); });

    // add the x Axis
    svg.append("g")
      .attr("transform", "translate(0," + height + ")")
      .call(d3.axisBottom(x));

    // add the y Axis
    svg.append("g")
      .call(d3.axisLeft(y).ticks(Math.min(yMax, 5)).tickFormat(d3.format("d")));


    // make a img base64
    let html = d3.select("#pubsChart svg").node().parentNode.innerHTML
    let imgSrc = "data:image/svg+xml;base64," + btoa(html)
    let img = `<img src = ${imgSrc}>`
    d3.select("#pubsChart").html(img)
  }
}


$(document).ready(function() {
    pubChart.onLoad();
});
