export default {
  install: (app, option) => {
    app.config.globalProperties.$watchAll = (property, vue) => {
      const options = { flush: 'post', deep: true }

      if (vue.unwatch === undefined) {
        vue.unwatch = {}
      }

      vue.unwatch[property] = vue.$watch(property, () => {
        if (vue.lastStatusTimeOut) {
          clearTimeout(vue.lastStatusTimeOut)
        }
        vue.updateStatus = 'Updating changes ...'
        vue.lastStatusTimeOut = setTimeout(() => {
          vue.lastStatusTimeOut = null
          vue.updateStatus = 'All save'
        }, 3000)
      }, options)
    }

    app.config.globalProperties.$watchSurvey = (property, vue, deepValue) => {
      const options = { flush: 'post', deep: !!deepValue }

      if (vue.unwatch === undefined) {
        vue.unwatch = {}
      }

      vue.unwatch[property] = vue.$watch(property, (newVal, oldVal) => {
        if (vue.lastTimeOut) {
          clearTimeout(vue.lastTimeOut)
        }
        vue.lastTimeOut = setTimeout(() => vue.updateData(res => {
          vue.lastTimeOut = null
          console.log('Updated:', property, 'Status:', res.data)
        }, newVal, oldVal), 3000)
      }, options)
    }
  }
}
