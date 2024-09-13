import moment from 'moment';
import React, { useEffect, useState } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { Card, CardBody, CardHeader, UncontrolledCollapse } from 'reactstrap';
import * as roles from "../../../helpers/user_role_helper";

type CaseActivityProps = {
    selectedTenant: any;
    caseActivity: any;
    setSingleCaseActivity: any;
    setDeleteModal: any;
    handleEditCaseActivityClick: any;
    toggled: boolean;
};

const CaseActivityCard = ({
	selectedTenant,
	caseActivity,
	setSingleCaseActivity,
	setDeleteModal,
	handleEditCaseActivityClick,
	toggled,
}: CaseActivityProps) => {
	const { id } = useParams();
	const navigate = useNavigate();

    const [isOpen, setIsOpen] = useState(false);
    
	const handleDeleteCaseActivityClick = (data: any) => {
		setSingleCaseActivity(data);
		setDeleteModal(true);
	};

    const clickToggle = () => setIsOpen(!isOpen);

    useEffect(() => {
		setIsOpen(toggled);
	}, [toggled]);


	return (
		<React.Fragment>
			<div className="mb-3 accordion accordion-flush">
				<div className="accordion-item">
					<CardHeader
						className="py-2 accordion-header"
						style={{ cursor: "pointer;" }}
					>
						<div
							className="row accordion-button bg-transparent shadow-none"
							id={"activity-" + caseActivity.caseActivityID}
							style={{ padding: "0px" }}
							onClick={clickToggle}
						>
							<div className="col-sm-9">
								<div className="hstack gap-3 flex-wrap">
									{moment(
										caseActivity.caseActivityDate
									).format("MM-DD-YYYY")}
									<div className="vr"></div>
									By: {caseActivity.fullName}
									{caseActivity.duration && (
										<>
											<div className="vr"></div>
											{caseActivity.duration}
										</>
									)}
									{!roles.isLowerRole(
										selectedTenant.roleID
									) &&
										caseActivity.isPublic && (
											<>
												<div className="vr"></div>
												<span className="badge bg-warning-subtle text-warning">
													Public Record
												</span>{" "}
											</>
										)}
								</div>
							</div>
						</div>
					</CardHeader>
					<UncontrolledCollapse
						toggler={"#activity-" + caseActivity.caseActivityID}
						isOpen={isOpen}
					>
						<CardBody>
							<div
								dangerouslySetInnerHTML={{
									__html: caseActivity.text,
								}}
							/>
						</CardBody>
					</UncontrolledCollapse>
				</div>
			</div>
		</React.Fragment>
	);
};

export default CaseActivityCard
