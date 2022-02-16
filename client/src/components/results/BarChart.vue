<template>
	<div class="chart">
		<vue3-chart-js
			:id="doughnutChart.id"
			:type="doughnutChart.type"
			:data="doughnutChart.data"
			@before-render="beforeRenderLogic"
		></vue3-chart-js>
	</div>
</template>

<script>
import Vue3ChartJs from '@j-t-mcc/vue3-chartjs'

// backgroundColor: ["#41B883", "#E46651", "#00D8FF", "#DD1B16"]

export default {
  name: 'App',
  components: {
    Vue3ChartJs
  },
  props: {
    answers: Array
  },
  setup () {
    const doughnutChart = {
      id: 'doughnut',
      type: 'doughnut',
      data: {
        labels: [],
        datasets: [
          {
            backgroundColor: [],
            data: []
          }
        ]
      }
    }

    const backgroundColor = ['#41B883', '#E46651', '#00D8FF', '#DD1B16',
      '#8E44AD', '#F1C40F', '#FF7000']

    const beforeRenderLogic = (event) => {
      // ...
      // if(a === b) {
      //  event.preventDefault()
      // }
    }

    return {
      doughnutChart,
      beforeRenderLogic,
      backgroundColor
    }
  },
  created () {
    for (let i = 0; i < this.answers.length; i++) {
      this.doughnutChart.data.labels.push(this.answers[i].Answer)
      this.doughnutChart.data.datasets[0].data
        .push(this.answers[i].Total)
      this.doughnutChart.data.datasets[0].backgroundColor
        .push(this.backgroundColor[i % this.backgroundColor.length])
    }
  }
}
</script>

<style>
</style>
