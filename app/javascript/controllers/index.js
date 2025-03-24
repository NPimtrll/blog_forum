import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"

import TrendingTagsController from "./trending_tags_controller";

application.register("trending-tags", TrendingTagsController);
eagerLoadControllersFrom("controllers", application);
