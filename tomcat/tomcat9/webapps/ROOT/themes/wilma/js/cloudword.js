var cloudword = {

    baseUrl: baseUrl,

    onLoad: function() {
      this.getKeywords();
      this.bindEventListeners();
    },


    bindEventListeners: function() {
      document.getElementById('word-selection').addEventListener('click', function(e) {
        if (e.target.name !== 'word-selection') return;
        cloudword.getKeywords(e.target.value)
      })
    },

    getKeywords: function(requestVal) {
      if (!requestVal) { requestVal = $('input[name=word-selection]:checked').val() }

      $.ajax({
          url: `${cloudword.baseUrl}/ur/data/keyword/${requestVal}`,
          dataType: 'json',
          data: {individualUri: individualUri},
          complete: function(xhr, status) {
              var results = jQuery.parseJSON(xhr.responseText);
              var cloudEl = document.getElementById('cloud');

              if (cloudEl.hasChildNodes()) cloudEl.firstChild.remove();
              if (cloudEl.innerHTML.length > 10) { cloudEl.innerHTML = undefined}

              if (results.length < 5) {
                cloudEl.innerHTML = 'Current selection cannot identify at least 5 keywords to make a cloud.';
              } else {
                cloudword.drawCloud(results, {width: 600, height: 400})
              }
          }
      });
    },

    drawCloud: function(drawInput, options) {
      // Next you need to use the layout script to calculate the placement, rotation and size of each word:

      var maxKeywords = options.maxKeywords || 30;

      var width = options.width || 400;
      var height = options.height || 180;

      var scaleRange = options.scaleRange || [15, 50];
      var keywordScale = d3.scale.linear().range(scaleRange);
      var fill = d3.scale.category20();

      if (drawInput.length > maxKeywords) {
        drawInput = drawInput.sort((a, b) => b.size - a.size)
                .filter((el, idx) => idx < maxKeywords);
      }

      keywordScale.domain([
        d3.min(drawInput, function(d) { return d.size; }),
        d3.max(drawInput, function(d) { return d.size; })
      ]);

      d3.layout.cloud()
        .size([width, height])
        .words(drawInput)
        .rotate(function() {
          return ~~(Math.random() * 2) * 90;
        })
        .font("Impact")
        .fontSize(function(d) {
          return keywordScale(d.size);;
        })
        .on("end", draw)
        .start();

        // Finally implement `draw`, which performs the D3 drawing:
        // apply D3.js drawing API
        function draw(words) {
          d3.select("#cloud").append("svg")
            .attr("width", width)
            .attr("height", height)
            .append("g")
            .attr("transform", "translate(" + ~~(width / 2) + "," + ~~(height / 2) + ")")
            .selectAll("text")
            .data(words)
            .enter().append("text")
            .style("font-size", function(d) {
              return d.size + "px";
            })
            .style("-webkit-touch-callout", "none")
            .style("-webkit-user-select", "none")
            .style("-khtml-user-select", "none")
            .style("-moz-user-select", "none")
            .style("-ms-user-select", "none")
            .style("user-select", "none")
            .style("cursor", "default")
            .style("font-family", "Impact")
            .style("fill", function(d, i) {
              return fill(i);
            })
            .attr("text-anchor", "middle")
            .attr("transform", function(d) {
              return "translate(" + [d.x, d.y] + ")rotate(" + d.rotate + ")";
            })
            .text(function(d) {
              return d.text;
            });
        }

        // set the viewbox to content bounding box (zooming in on the content, effectively trimming whitespace)
        var svg = document.getElementsByTagName("svg")[0];
        var bbox = svg.getBBox();
        var viewBox = [bbox.x, bbox.y, bbox.width, bbox.height].join(" ");
        svg.setAttribute("viewBox", viewBox);
    }
}

$(document).ready(function() {
    cloudword.onLoad();
});
