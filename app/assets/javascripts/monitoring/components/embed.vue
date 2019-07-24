<script>
import { mapActions, mapState } from 'vuex';
import GraphGroup from './graph_group.vue';
import MonitorAreaChart from './charts/area.vue';
import { sidebarAnimationDuration, timeWindowsKeyNames, timeWindows } from '../constants';
import { getTimeDiff } from '../utils';

let sidebarMutationObserver;

export default {
  components: {
    GraphGroup,
    MonitorAreaChart,
  },
  props: {
    dashboardUrl: {
      type: String,
      required: true,
    },
  },
  data() {
    return {
      params: {
        ...getTimeDiff(timeWindows[timeWindowsKeyNames.eightHours]),
      },
      elWidth: 0,
    };
  },
  computed: {
    ...mapState('monitoringDashboard', ['groups', 'metricsWithData']),
    groupData() {
      const groupsWithData = this.groups.filter(group => this.chartsWithData(group.metrics).length);
      if (groupsWithData.length) {
        return groupsWithData[0];
      }
      return null;
    },
  },
  mounted() {
    this.setInitialState();
    this.fetchMetricsData(this.params);
    sidebarMutationObserver = new MutationObserver(this.onSidebarMutation);
    sidebarMutationObserver.observe(document.querySelector('.layout-page'), {
      attributes: true,
      childList: false,
      subtree: false,
    });
  },
  beforeDestroy() {
    if (sidebarMutationObserver) {
      sidebarMutationObserver.disconnect();
    }
  },
  methods: {
    ...mapActions('monitoringDashboard', [
      'fetchMetricsData',
      'setEndpoints',
      'setFeatureFlags',
      'setShowErrorBanner',
    ]),
    chartsWithData(charts) {
      return charts.filter(chart =>
        chart.metrics.some(metric => this.metricsWithData.includes(metric.metric_id)),
      );
    },
    onSidebarMutation() {
      setTimeout(() => {
        this.elWidth = this.$el.clientWidth;
      }, sidebarAnimationDuration);
    },
    setInitialState() {
      this.setFeatureFlags({
        prometheusEndpointEnabled: true,
      });
      this.setEndpoints({
        dashboardEndpoint: this.dashboardUrl,
      });
      this.setShowErrorBanner(false);
    },
  },
};
</script>
<template>
  <div class="metrics-embed">
    <div v-if="groupData" class="row w-100 m-n2 pb-4">
      <monitor-area-chart
        v-for="graphData in chartsWithData(groupData.metrics)"
        :key="graphData.title"
        :graph-data="graphData"
        :container-width="elWidth"
        group-id="monitor-area-chart"
        :project-path="null"
        :show-border="true"
      />
    </div>
  </div>
</template>