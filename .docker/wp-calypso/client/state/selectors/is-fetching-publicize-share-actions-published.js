/**
 * External dependencies
 */

import { get } from 'lodash';

/**
 * @param {Object} state Global state tree
 * @param {Number} siteId Site ID
 * @param {Number} postId Post ID
 * @return {Boolean} true if we are fetching publicize share actions for a post
 */
export default function isFetchingPublicizeShareActionsPublished( state, siteId, postId ) {
	return get( state, [ 'sharing', 'sharePostActions', 'published', siteId, postId ], false );
}
