<?php

namespace CollectiveAccessService;

class StatisticsService extends BaseServiceClient {
	# ----------------------------------------------
	public function __construct($base_url){
		parent::__construct($base_url, "Statistics");

		$this->setRequestMethod("GET");
	}
	# ----------------------------------------------
}
