import statusIcon from '../mr_widget_status_icon';
import mrWidgetMergeHelp from '../../components/mr_widget_merge_help';

export default {
  name: 'MRWidgetMissingBranch',
  props: {
    mr: { type: Object, required: true },
  },
  components: {
    'mr-widget-merge-help': mrWidgetMergeHelp,
    statusIcon,
  },
  computed: {
    missingBranchName() {
      return this.mr.sourceBranchRemoved ? 'source' : 'target';
    },
    message() {
      return `If the ${this.missingBranchName} branch exists in your local repository, you can merge this merge request manually using the command line`;
    },
  },
  template: `
    <div class="mr-widget-body media">
      <status-icon status="failed" showDisabledButton />
      <div class="media-body space-children">
        <span class="bold js-branch-text">
          <span class="capitalize">
            {{missingBranchName}}
          </span> branch does not exist.
          Please restore it or use a different {{missingBranchName}} branch
          <i
            class="fa fa-question-circle has-tooltip"
            :title="message" />
        </span>
      </div>
    </div>
  `,
};
